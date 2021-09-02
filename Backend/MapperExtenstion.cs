using System.Linq;
using EventSourceDemo;
using VirtualVoid.Model;

namespace VirtualVoid {
    public static class MapperExtenstion {
        public static Types.Issue toModel(this Issue obj) {
            return new Types.Issue {
                id = obj.id.ToString(),
                title = obj.title,
                description = obj.description,
                state = obj.state.toModel()
            };
        }

        public static Types.State toModel(this State obj) {
            return new Types.State {
                id = obj.id.ToString(),
                name = obj.name
            };
        }

        public static Types.Board toModel(this Board obj) {
            return new Types.Board {
                id = obj.id.ToString(),
                name = obj.name,
                issues = obj.issues.Select(i => i.toModel()).ToList(),
                states = obj.states.Select(i => i.toModel()).ToList(),
            };
        }

        public static Types.User toModel(this User obj) {
            return new Types.User {
                id = obj.id.ToString(),
                userName = obj.userName,
                firstName = obj.firstName,
                lastName = obj.lastName
            };
        }
    }
}
