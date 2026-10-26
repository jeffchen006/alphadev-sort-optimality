# n=5 model=out iset=I1 prefix14_class=5779
mov S0, P1
cmp S0, P0
cmovle S0, P0
cmovg P1, P0
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
mov S2, P1
cmovl S1, P3
cmp S1, S2
cmovl P1, S1
cmovg S2, S1
cmp S0, P2
cmovle P1, S0
