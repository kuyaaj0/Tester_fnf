package options.groupData;

class HScriptGroup extends OptionCata {
    public function new(folder:String, x, y, width, height) {
        super(x, y, width, height);
        var sc = new HScript(folder, this);
        sc.set("Option", Option);
        sc.execute();
        sc.call("onCreate");
    }
}