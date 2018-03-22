#include <core/Godot.hpp>
#include <Reference.hpp>

using namespace godot;

class ZeroScript : public GodotScript<Reference> {

  GODOT_CLASS(ZeroSploit);

public:

  ZeroScript() {}

  void test_void_method() {
    Godot::print("This is a test");
  }

  String method(Variant arg) {
    String ret;
    ret = "Received from gdnative: " + arg.operator String();
    Godot::print(ret);

    return ret;
  }

  static void _register_methods() {
    register_method((char *)"method", &ZeroScript::method);
    register_property((char *)"base/name", &ZeroScript::_name, String("ZeroScript"));
  }

  String _name;

};

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o) {
  godot::Godot::gdnative_init(o);
}

extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o) {
  godot::Godot::gdnative_terminate(o);
}

extern "C" void GDN_EXPORT godot_nativescript_init(void *handle) {
  godot::Godot::nativescript_init(handle);
  godot::register_class<ZeroScript>();
}
