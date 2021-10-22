void Main()
{
}

void Render()
{
    CSceneVehicleVis@ vis = GetVis();
    if (vis is null) {
        return;
    }

    CSceneVehicleVisState@ state = vis.AsyncState;
    
    vec2 size = Setting_General_Size;
    vec2 pos = Setting_General_Pos;
    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 origin = pos * (screenSize - size);
    
    // border
    float border_radius = 2.0;
    nvg::BeginPath();
    nvg::RoundedRect(origin.x, origin.y, size.x, size.y, border_radius);
    
    nvg::StrokeColor(Setting_General_BorderColor);
    nvg::FillColor(Setting_General_FillColor);
    
    nvg::Fill();
    nvg::Stroke();
    nvg::ClosePath();
    
    nvg::BeginPath();
    
    nvg::MoveTo(vec2(origin.x, origin.y + size.y * 0.5));
    nvg::LineTo(vec2(origin.x + size.x, origin.y + size.y * 0.5));
  
    nvg::FillColor(Setting_General_BorderColor);
    nvg::Fill();
    
    nvg::ClosePath();
    
    // marker
    nvg::BeginPath();
    
    auto y = state.WorldCarUp.y;
    auto angle = Math::Acos(y) / 3.14159265359;
    auto ycoord = origin.y + (size.y - border_radius) * angle + border_radius * 0.5;
    
    nvg::MoveTo(vec2(origin.x + border_radius * 0.5, ycoord));
    nvg::LineTo(vec2(origin.x + size.x - border_radius * 0.5, ycoord));
  
    nvg::FillColor(Setting_General_MarkerColor);
    nvg::Fill();
    
    nvg::ClosePath();   
}

// The following code was copied from the OpenPlanet Dashboard plugin found at https://github.com/codecat/tm-dashboard
CSmPlayer@ GetViewingPlayer()
{
    auto playground = GetApp().CurrentPlayground;
    if (playground is null || playground.GameTerminals.Length != 1) {
        return null;
    }
    return cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
}

// The following code was copied from the OpenPlanet Dashboard plugin found at https://github.com/codecat/tm-dashboard
CSceneVehicleVis@ GetVis()
{
    auto app = GetApp();
    
#if !MP4
    auto sceneVis = app.GameScene;
    if (sceneVis is null) {
        return null;
    }
    CSceneVehicleVis@ vis = null;
#else
    CGameScene@ sceneVis = null;
    CSceneVehicleVisInner@ vis = null;
#endif
    
    auto player = GetViewingPlayer();
    if (player !is null) {
        @vis = Vehicle::GetVis(sceneVis, player);
    } else {
        @vis = Vehicle::GetSingularVis(sceneVis);
    }

    if (vis is null) {
        return null;
    }
    
#if TMNEXT
    uint entityId = Vehicle::GetEntityId(vis);
    if ((entityId & 0xFF000000) == 0x04000000) {
        // If the entity ID has this mask, then we are either watching a replay, or placing
        // down the car in the editor. So, we will check if we are currently in the editor,
        // and stop if we are.
        if (cast<CGameCtnEditorFree>(app.Editor) !is null) {
            return null;
        }
    }
#endif

    return vis;
}
