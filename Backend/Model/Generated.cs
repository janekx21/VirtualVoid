using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;

namespace VirtualVoid.Model {
  public class Types {
    
    #region Board
    public class Board {
      #region members
      [JsonProperty("id")]
      public string id { get; set; }
    
      [JsonProperty("name")]
      public string name { get; set; }
    
      [JsonProperty("issues")]
      public List<Issue> issues { get; set; }
    
      [JsonProperty("states")]
      public List<State> states { get; set; }
      #endregion
    }
    #endregion
    
    #region BoardInput
    public class BoardInput {
      #region members
      [Required]
      [JsonRequired]
      public string id { get; set; }
    
      public string name { get; set; }
      #endregion
    
      #region methods
      public dynamic GetInputObject()
      {
        IDictionary<string, object> d = new System.Dynamic.ExpandoObject();
    
        var properties = GetType().GetProperties(System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public);
        foreach (var propertyInfo in properties)
        {
          var value = propertyInfo.GetValue(this);
          var defaultValue = propertyInfo.PropertyType.IsValueType ? Activator.CreateInstance(propertyInfo.PropertyType) : null;
    
          var requiredProp = propertyInfo.GetCustomAttributes(typeof(JsonRequiredAttribute), false).Length > 0;
    
          if (requiredProp || value != defaultValue)
          {
            d[propertyInfo.Name] = value;
          }
        }
        return d;
      }
      #endregion
    }
    #endregion
    
    #region Issue
    public class Issue {
      #region members
      [JsonProperty("id")]
      public string id { get; set; }
    
      [JsonProperty("title")]
      public string title { get; set; }
    
      [JsonProperty("description")]
      public string description { get; set; }
    
      [JsonProperty("state")]
      public State state { get; set; }
      #endregion
    }
    #endregion
    
    #region Mutation
    public class Mutation {
      #region members
      [JsonProperty("createBoard")]
      public Board createBoard { get; set; }
    
      [JsonProperty("updateBoard")]
      public Board updateBoard { get; set; }
    
      [JsonProperty("deleteBoard")]
      public string deleteBoard { get; set; }
      #endregion
    }
    #endregion
    
    #region Query
    public class Query {
      #region members
      [JsonProperty("me")]
      public User me { get; set; }
    
      [JsonProperty("boards")]
      public List<Board> boards { get; set; }
      #endregion
    }
    #endregion
    
    #region State
    public class State {
      #region members
      [JsonProperty("id")]
      public string id { get; set; }
    
      [JsonProperty("name")]
      public string name { get; set; }
      #endregion
    }
    #endregion
    
    #region User
    public class User {
      #region members
      [JsonProperty("id")]
      public string id { get; set; }
    
      [JsonProperty("userName")]
      public string userName { get; set; }
    
      [JsonProperty("firstName")]
      public string firstName { get; set; }
    
      [JsonProperty("lastName")]
      public string lastName { get; set; }
      #endregion
    }
    #endregion
  }
  
}
