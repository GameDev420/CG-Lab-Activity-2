# CG-Lab-Activity-2

I chose to extend the stencil shaders as they seemed the most interesting and I know the least about.

While not particularly useful, I noticed that enabling color output on the object/shader writing to the stencil buffer applies the color of visible fragments above (or instead of) the would-be fragment below. This can create some interesting filter effects even just with color and transparency.

It does have noticeable clipping when multiple objects overlap each other, even if not physically touching, but I would rather not delve into rendering queues for such a delicate shader at this point.

While screen-space effects are likely more efficient and straightforward, having an effect applied to objects in world-space can be better for genres such as VR games, where diegetic elements and interfaces are vital parts of the experience. That being said, the specific examples below are geared toward the former for simplicity.

# Fresnel Stencil

https://github.com/user-attachments/assets/4ac1c9a8-4ff8-455f-904c-784290cf2787

<img width="466" height="354" alt="image" src="https://github.com/user-attachments/assets/e4c91c5c-8178-413b-956b-cd0c01d67e24" />

The idea here would be animating a portal opening-like effect, but could be used for many other purposes or optical illusions. I tried to match the fresnel color to that of the wall behind it (without clamping, as HDR color values could be useful elsewhere), but the material color and standard fresnel properties can be changed at will.

# Solid Color Stencil

https://github.com/user-attachments/assets/59a49dc3-c4f1-45e8-a14a-c6e320a1a01a

A bit more abstract, but I thought the right could be used for dynamic shadow-art visuals, similar to the iconic music video for _Bad Apple!!_, while the left exudes an overly joyous feeling, but also reminded me of a scene from the second level of _Boneworks_ (shown below) that gave a more wonderous impression on my first playthrough.

**Boneworks Reference Image/Inspiration**

<img width="407" height="480" alt="BoneworksMuseumReference" src="https://github.com/user-attachments/assets/0a7967db-c960-4a2b-b62e-8677c3dc33cb" />
