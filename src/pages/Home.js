import React, { useEffect, useState } from "react";
import axios from "axios";
import { Link } from "react-router-dom";
const { DEMOAPP_BACKEND_URL } = require('../constants');

export default function Home() {
  const [users, setUsers] = useState([]);

  // eslint-disable-next-line

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    const result = await axios.get(
      `${DEMOAPP_BACKEND_URL}/users`,
      {
        headers: {
          "Access-Control-Allow-Origin": `${DEMOAPP_BACKEND_URL}`,
          "Access-Control-Allow-Headers": 'Content-Type, Authorization'
        }
      }
    );   // Updated by Paul Gilber
    setUsers(result.data);
  };

  const deleteUser = async (id) => {
    await axios.delete(`${DEMOAPP_BACKEND_URL}/user/${id}`);   // Updated by Paul Gilber
    loadUsers();
  };

  return (
    <div className="container">
      <div className="py-4">
        <table className="table border shadow">
          <thead>
            <tr>
              <th scope="col">S.N</th>
              <th scope="col">Name</th>
              <th scope="col">Username</th>
              <th scope="col">Email</th>
              <th scope="col">Action</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <th scope="row" key={user.id}>
                  {user.id}
                </th>
                <td>{user.name}</td>
                <td>{user.username}</td>
                <td>{user.email}</td>
                <td>
                  <Link
                    className="btn btn-primary mx-2"
                    to={`/viewuser/${user.id}`}
                  >
                    View
                  </Link>
                  <Link
                    className="btn btn-outline-primary mx-2"
                    to={`/edituser/${user.id}`}
                  >
                    Edit
                  </Link>
                  <button
                    className="btn btn-danger mx-2"
                    onClick={() => deleteUser(user.id)}
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
