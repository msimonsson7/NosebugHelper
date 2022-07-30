void Main()
{
}

void Render()
{
    CSceneVehicleVisState@ state = VehicleState::ViewingPlayerState();
    if (state is null) {
        return;
    }
    
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
