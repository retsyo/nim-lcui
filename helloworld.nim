const dllname = "LCUI.dll"

type
    #~ typedef struct LCUI_WidgetRec_* LCUI_Widget;
    LCUI_Widget = pointer

{.push cdecl, importc, discardable, dynlib: dllname.}

#~ LCUI_API void LCUI_Init(void);
proc LCUI_Init*(){. importc: "LCUI_Init".}

#~ LCUI_API int LCUI_Main(void);
proc LCUI_Main*(): cint {. importc: "LCUI_Main".}

#~ LCUI_API LCUI_Widget LCUIWidget_GetRoot(void);
proc LCUIWidget_GetRoot*(): LCUI_Widget {. importc: "LCUIWidget_GetRoot".}

#~ LCUI_API LCUI_Widget LCUIBuilder_LoadFile(const char *filepath);
proc LCUIBuilder_LoadFile*(filepath: cstring): LCUI_Widget {. importc: "LCUIBuilder_LoadFile".}

#~ LCUI_API int Widget_Append(LCUI_Widget container, LCUI_Widget widget);
proc Widget_Append*(container: LCUI_Widget, widget: LCUI_Widget): int {. importc: "Widget_Append".}

#~ LCUI_API int Widget_Unwrap(LCUI_Widget widget);
proc Widget_Unwrap(widget: LCUI_Widget): int {. importc: "Widget_Unwrap".}

#~ LCUI_API LCUI_Widget LCUIWidget_GetById(const char *id);
proc LCUIWidget_GetById(id: cstring): LCUI_Widget {. importc: "LCUIWidget_GetById".}

#~ typedef void(*LCUI_WidgetEventFunc)(LCUI_Widget, LCUI_WidgetEvent, void*);
type
    LCUI_WidgetEvent* = pointer
    LCUI_WidgetEventFunc* = proc(widget: LCUI_Widget,
        widget_evt: LCUI_WidgetEvent, data: pointer) {.nimcall.}
    Tdestroy_data* = proc(d: pointer) {.nimcall.}

#~ LCUI_API int Widget_BindEventById(LCUI_Widget widget, int event_id,
        #~ LCUI_WidgetEventFunc func, void *data,
        #~ void(*destroy_data)(void*));
proc Widget_BindEventById(widget: LCUI_Widget, event_id: int,
        fun: LCUI_WidgetEventFunc,  data: pointer,
        destroy_data: Tdestroy_data): int {. importc: "Widget_BindEventById".}

#~ LCUI_API int Widget_BindEvent(LCUI_Widget widget, const char *event_name,
        #~ LCUI_WidgetEventFunc func, void *data,
        #~ void(*destroy_data)(void*));
proc Widget_BindEvent(widget: LCUI_Widget, event_name: cstring,
        fun: LCUI_WidgetEventFunc, data: pointer,
        destroy_data: Tdestroy_data): int {. importc: "Widget_BindEvent".}

#~ LCUI_API size_t TextEdit_GetTextW(LCUI_Widget w, size_t start,
        #~ size_t max_len, wchar_t *buf);
type size_t = int
proc TextEdit_GetTextW(w: LCUI_Widget, start: size_t,
        max_len: size_t, buf: WideCString):  size_t {. importc: "TextEdit_GetTextW".}

#~ LCUI_API int TextView_SetTextW(LCUI_Widget w, const wchar_t *text);
proc TextView_SetTextW(w: LCUI_Widget, text: WideCString): int {. importc: "TextEdit_SetTextW".}

{.pop.}

proc OnBtnClick(self: LCUI_Widget, e: LCUI_WidgetEvent, arg: pointer) {.cdecl.}=
    var s = newWideCString("", 256)
    var edit = LCUIWidget_GetById("edit");
    var txt = LCUIWidget_GetById("text-hello");

    TextEdit_GetTextW(edit, 0, 255, s);
    TextView_SetTextW(txt, s);


proc main(): int {.discardable.}=

    var root, pack, btn: LCUI_Widget;

    LCUI_Init();
    root = LCUIWidget_GetRoot();
    pack = LCUIBuilder_LoadFile("helloworld.xml");
    if pack == nil:
        return -1
    Widget_Append(root, pack);
    Widget_Unwrap(pack);
    btn = LCUIWidget_GetById("btn");
    Widget_BindEvent(btn, "click",
        cast[LCUI_WidgetEventFunc](OnBtnClick),
        cast[pointer](nil), cast[Tdestroy_data](nil)
        );
    return LCUI_Main();

main()
