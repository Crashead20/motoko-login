import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Array "mo:base/Array";

// Estructura para almacenar los usuarios
actor Backend {

  // Base de datos en memoria que mapea el nombre de usuario a la contraseña (texto)
  private var users : HashMap.HashMap<Text, Text> =
    HashMap.HashMap<Text, Text>(10, Text.equal, Text.hash);

  // Almacena los usuarios que han iniciado sesión
  private var loggedInUsers : HashMap.HashMap<Text, Bool> =
    HashMap.HashMap<Text, Bool>(10, Text.equal, Text.hash);

  // Función para agregar un nuevo usuario
  public func addUser(username: Text, password: Text) : async Bool {
    if (username == "" or password == "") {
      return false;
    };

    if (users.get(username) != null) {
      return false;
    };

    // Agregamos el nuevo usuario
    ignore users.put(username, password);
    return true;
  };

  // Función de login
  public func login(username: Text, password: Text) : async Bool {
    if (username == "" or password == "") {
      return false;
    };

    switch (users.get(username)) {
      case (?storedPassword) {
        if (storedPassword == password) {
          ignore loggedInUsers.put(username, true);
          return true;
        } else {
          return false;
        }
      };
      case null {
        return false;
      }
    }
  };

  // Función para verificar si un usuario está logueado
  public func isLoggedIn(username: Text) : async Bool {
    switch (loggedInUsers.get(username)) {
      case (?true) { return true; };
      case _ { return false; };
    }
  };


  // Función para listar los usuarios registrados
  public func listUsers() : async [Text] {
    var usersList : [Text] = [];
    let entries = users.entries();

    for (entry in entries) {
      let (username, _) = entry;
      usersList := Array.append<Text>(usersList, [username]);
    };

    return usersList;
  };
};
