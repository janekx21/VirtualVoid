using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;

namespace Backend {
    public class MyTypes {
        #region Issue

        public class Issue {
            #region members

            [JsonProperty("id")] public string id { get; set; }

            [JsonProperty("title")] public string title { get; set; }

            [JsonProperty("description")] public string description { get; set; }

            [JsonProperty("children")] public List<Issue> children { get; set; }

            #endregion
        }

        #endregion

        #region Query

        public class Query {
            #region members

            [JsonProperty("me")] public User me { get; set; }

            [JsonProperty("issues")] public List<Issue> issues { get; set; }

            #endregion
        }

        #endregion

        #region User

        public class User {
            #region members

            [JsonProperty("id")] public string id { get; set; }

            [JsonProperty("name")] public string name { get; set; }

            #endregion
        }

        #endregion
    }
}
