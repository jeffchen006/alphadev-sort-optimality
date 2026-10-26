# n=5 model=out iset=I1 prefix14_class=2779
cmp P1, P2
cmovg S1, P1
cmovle S1, P2
mov S2, P0
cmovg P1, P2
cmp P3, S2
cmovge S2, P3
cmovg P3, P0
cmp S1, S2
cmovge S0, S2
cmovge S2, S1
cmovle S0, S1
mov S2, S0
cmp P1, P3
