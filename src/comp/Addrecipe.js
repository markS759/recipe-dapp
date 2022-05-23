import React from 'react';
import { useState } from "react";

export const AddRecipe = (props) => {

const [title, setTitle] = useState('');
const [description, setDescription] = useState('');
const [image, setImage] = useState('');
const [price, setPrice] = useState(0);
const [show, setShow] = useState(false);


const handleSetshow =() =>{
  setShow(!show);
}







  return <div>
    <button type="button" onClick={()=> {handleSetshow();}} class="btn btn-dark mt-2">Add new Recipe</button>


      
      {show ? (
      <form>
  <div class="form-row">
    
      <input type="text" class="form-control" value={title}
           onChange={(e) => setTitle(e.target.value)} placeholder="Title"/>

<input type="text" class="form-control" value={description}
           onChange={(e) => setDescription(e.target.value)} placeholder="description"/>

<input type="text" class="form-control" value={image}
           onChange={(e) => setImage(e.target.value)} placeholder="Image"/>
           
      <input type="text" class="form-control mt-2" value={price}
           onChange={(e) => setPrice(e.target.value)} placeholder="Price"/>

      <button type="button" onClick={()=>props.addRecipe(title, description, image, price)} class="btn btn-primary mt-2">Add</button>

  </div>
</form>
      ):(

        <button type="button" onClick={()=> {handleSetshow()}} class="btn btn-dark mt-2">Add new Recipe</button>
      )
    
    }
  </div>;
};
