import React from 'react'
import { useState } from "react";


export const Recipes = ( props ) => {
 const [newPrice, setnewPrice] = useState('');


    return (
      <div className="row pt-4">
        {props.recipes.map((r) => (
          <div className="col-4">
            <div className="card" key={r.index}>
              <img
                className="card-img-top"
                src={r.image}
                alt="Card image cap"
              />
              <div className="card-body">
                <h5 className="card-title">{r.title}</h5>
                <h6 className="card-subtitle">{r.price} cUSD</h6>
                <p className="card-text">{r.description}</p>
              
                  {props.walletAddress !== r.owner && (
                  <button
                    onClick={() => props.buyRecipe(r.index)}
                    className="btn btn-primary"
                  >
                    Buy Recipe
                  </button>)}
                  
                { props.walletAddress === r.owner &&(
                  <form>
                  <div class="form-roww pt-2 ">
                    <input
                      type="text"
                      className="form-control"
                      value={newPrice}
                      onChange={(e) => setnewPrice(e.target.value)}
                      placeholder="new price"
                    />
                    <button
                      type="submit"
                      onClick={() => props.changePrice(r.index, newPrice)}
                      className="btn btn-success pt-1"
                    >
                      Change Price
                    </button>
                  </div>
                </form>
                       )}
              </div>
            </div>
          </div>
      
        ))}
        ;
      </div>
    );
  };
  export default Recipes;