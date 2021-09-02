using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class StateType : ObjectGraphType<Types.State> {
        public StateType() {
            Field(o => o.id);
            Field(o => o.name);
        }
    }
}
