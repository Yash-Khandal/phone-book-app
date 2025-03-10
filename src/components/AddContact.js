 import React, { useState } from "react";

const AddContact = ({ addNewContact }) => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [city, setCity] = useState("");
  const [avatar, setAvatar] = useState(null);

  // Handle image upload
  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setAvatar(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };

  // Handle form submission
  const handleSubmit = (event) => {
    event.preventDefault();
    if (name && email && city) {
      const newUser = {
        name,
        email,
        city,
        avatar,
      };

      addNewContact(newUser); // Send new user data to App.js

      // Clear input fields
      setName("");
      setEmail("");
      setCity("");
      setAvatar(null);
    } else {
      alert("Please fill in all fields.");
    }
  };

  return (
    <div className="card p-4 shadow">
      <form onSubmit={handleSubmit}>
        <div className="mb-3">
          <label className="form-label">Name</label>
          <input
            type="text"
            className="form-control"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </div>

        <div className="mb-3">
          <label className="form-label">Email</label>
          <input
            type="email"
            className="form-control"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>

        <div className="mb-3">
          <label className="form-label">City</label>
          <input
            type="text"
            className="form-control"
            value={city}
            onChange={(e) => setCity(e.target.value)}
            required
          />
        </div>

        <div className="mb-3">
          <label className="form-label">Profile Picture</label>
          <input
            type="file"
            className="form-control"
            accept="image/*"
            onChange={handleImageUpload}
          />
          {avatar && (
            <img
              src={avatar}
              alt="Preview"
              className="mt-3 rounded"
              style={{ width: "80px", height: "80px" }}
            />
          )}
        </div>

        <button type="submit" className="btn btn-primary w-100">
          Add Contact
        </button>
      </form>
    </div>
  );
};

export default AddContact;