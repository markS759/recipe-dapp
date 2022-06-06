import React from 'react'
import { useState } from "react";


export const Recipes = ( props ) => {



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
                <h6 className="card-subtitle">{r.price / 1000000000000000000} cUSD</h6>
                <p className="card-text">{r.description}</p>

                <p className="card-texxt">{r.forSale ? "This Recipe is For Sale": "Not for sale"}</p>
              
                  {props.walletAddress !== r.owner && r.forSale === true && (
                  <button
                    onClick={() => props.buyRecipe(r.index)}
                    className = "btn btn-primary"
                  >
                    Buy Recipe
                  </button>)}
                  
                { props.walletAddress === r.owner &&(
                    <button
                      type="submit"
                      onClick={() => props.deleteRecipe(r.index)}
                      className="btn btn-danger m-3"
                    >
                      Delete Recipe
                    </button>
                  

                
                       )}
                       {
                         props.walletAddress === r.owner &&(
                          <button
                          type="submit"
                          onClick={() => props.toggleForsale(r.index,)}
                          className="btn btn-success pt-1"
                        >
                          Toggle Forsale
                        </button>
                         )
                       }
              </div>
            </div>
          </div>
      
        ))}
        ;
      </div>
    );
  };
  export default Recipes;