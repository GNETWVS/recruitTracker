function rejectCallback(hObject, eventdata)
    hObject.UserData = 1;
    uiresume(gcbf);
end