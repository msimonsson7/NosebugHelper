// MIT License
// 
// Copyright (c) 2021 Melissa Geels
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// This file contains code to access some visual information that is not normally available. This
// code isn't entirely future-proof, so it might stop working after some game updates. If you want
// to use this code keep this in mind! Use `#max_game_version` to avoid crashes on unexpected game
// updates.

#if TMNEXT
namespace SceneVis
{
	// Gets a scene manager by its index. Prefer to use this instead of FindMgr, if you know the
	// index.
	CMwNod@ GetMgr(ISceneVis@ sceneVis, uint index)
	{
		uint managerCount = Dev::GetOffsetUint32(sceneVis, 0x8);
		if (index > managerCount) {
			error("Index out of range: there are only " + managerCount + " managers");
			return null;
		}

		return Dev::GetOffsetNod(sceneVis, 0x10 + index * 0x8);
	}

	// Get the number of managers available.
	uint GetMgrCount(ISceneVis@ sceneVis)
	{
		return Dev::GetOffsetUint32(sceneVis, 0x8);
	}

	// Looks up a manager by its type ID. Prefer to use GetMgr if you can.
	CMwNod@ FindMgr(ISceneVis@ sceneVis, uint classID)
	{
		uint sceneVisManagersOffset = 0x2C0;
		auto sceneVisManagers = Dev::GetOffsetNod(sceneVis, sceneVisManagersOffset);
		auto sceneVisManagersCount = Dev::GetOffsetUint32(sceneVis, sceneVisManagersOffset + 0x8);

		for (uint i = 0; i < sceneVisManagersCount; i++) {
			uint offset = i * 0x18;
			auto mgrClassID = Dev::GetOffsetUint32(sceneVisManagers, offset);
			if (mgrClassID == classID) {
				return Dev::GetOffsetNod(sceneVisManagers, offset + 0x8);
			}
		}

		return null;
	}

	// Get all manager class ID's.
	array<uint> GetMgrClassIds(ISceneVis@ sceneVis)
	{
		array<uint> ret;

		uint managerCount = GetMgrCount(sceneVis);
		while (ret.Length < managerCount) {
			ret.InsertLast(0);
		}

		uint sceneVisManagersOffset = 0x2C0;
		auto sceneVisManagers = Dev::GetOffsetNod(sceneVis, sceneVisManagersOffset);
		auto sceneVisManagersCount = Dev::GetOffsetUint32(sceneVis, sceneVisManagersOffset + 0x8);

		for (uint i = 0; i < sceneVisManagersCount; i++) {
			uint offset = i * 0x18;
			auto mgrClassID = Dev::GetOffsetUint32(sceneVisManagers, offset);
			auto mgrIndex = Dev::GetOffsetUint32(sceneVisManagers, offset + 0x10);
			ret[mgrIndex] = mgrClassID;
		}

		return ret;
	}
}
#endif
