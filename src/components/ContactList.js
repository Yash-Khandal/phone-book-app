import React from "react";

const ContactList = ({ contacts, setContacts }) => {
  const deleteContact = (id) => {
    if (!window.confirm("Are you sure you want to delete this contact?"))
      return;
    setContacts(contacts.filter((contact) => contact.id !== id));
  };

  return (
    <div className="mt-4">
      <h3>Users List</h3>
      <div className="table-responsive">
        <table className="table table-bordered table-hover mt-3">
          <thead className="table-dark">
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Email</th>
              <th>City</th>
              <th>Profile Pic</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {contacts.length > 0 ? (
              contacts.map((contact) => (
                <tr key={contact.id}>
                  <td>{contact.id}</td>
                  <td>{contact.name}</td>
                  <td>{contact.email}</td>
                  <td>{contact.city}</td>
                  <td>
                    <img
                      src={
                        contact.avatar ? contact.avatar : "/default-profile.png"
                      }
                      alt={contact.name}
                      className="img-thumbnail"
                      style={{
                        width: "50px",
                        height: "50px",
                        borderRadius: "50%",
                      }}
                    />
                  </td>
                  <td>
                    <button
                      onClick={() => deleteContact(contact.id)}
                      className="btn btn-danger btn-sm"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="6" className="text-center">
                  No users found.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ContactList;