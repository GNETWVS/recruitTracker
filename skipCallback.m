function skipCallback(hObject, eventdata)
    hObject.UserData = 1;
    uiresume(gcbf);
end