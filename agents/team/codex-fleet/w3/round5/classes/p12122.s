# n=5 model=out iset=I1 prefix14_class=12122
mov S1, P3
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmp P0, P1
cmovl S0, P1
cmovge S0, P0
mov S2, S1
cmovle P1, P0
cmp S1, P1
cmovle S1, P1
cmovg S2, P1
cmp P2, S0
cmovle P1, S0
