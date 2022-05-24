// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


// delete
// edit
// change price

contract RecipeDaap {

    uint internal recipesLength = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Recipe {
        address payable owner;
        string title;
        string recipeOfTheDish;
        string image;
        uint price;
    }

    mapping (uint => Recipe) internal recipes;
    
    //Maps index of the recepie to the array of addresses that has bought the recepie
    mapping(uint256 => address[]) internal buyers;

    function addRecipe(
        string memory _title,
        string memory _description,
        string memory _image,  
        uint _price

    ) public {
        
        recipes[recipesLength] = Recipe(
            payable(msg.sender),
            _title,
            _description,
            _image,
            _price
        );
        recipesLength++;
    }


    function getRecipe(uint _index) public view returns (
        address payable,
        string memory,  
        string memory, 
        uint 
    ) {
        return (
            recipes[_index].owner,
            recipes[_index].title,  
            recipes[_index].image, 
            recipes[_index].price
        );
    }

     function changeRecipePrice(uint _index, uint _price) public {
        require(msg.sender == recipes[_index].owner, "Only the owner can change the price");
        recipes[_index].price = _price;
    }
    
    function buyRecipe(uint _index) public payable  {
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            recipes[_index].owner,
            recipes[_index].price
          ),
          "Transfer failed."
        );
        buyers[_index].push(msg.sender);

    }

    //Function to retreive the secret recepie for the buyers
    function getRecipeOfTheDish(uint _index) public view returns(string memory){
        require(hasBought(_index) == true, "Need to buy the recipie to view the recepie");
        return recipes[_index].recipeOfTheDish;
    }

    //Function that checks if the user has bought the course or not
    function hasBought(uint _index) private view returns(bool){
        address[] memory boughtAdresses = buyers[_index];
        for (uint i = 0; i < boughtAdresses.length; i++) {
            if (boughtAdresses[i] == msg.sender) {
                return true;
            }
        }
        return false;
    }
    
    function getRecipesLength() public view returns (uint) {
        return (recipesLength);
    }
}