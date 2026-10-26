# n=5 model=out iset=I1 prefix14_class=1084
mov S2, P1
cmp P0, P3
mov S1, P3
cmovg S1, P0
cmovl P3, P0
mov S0, P3
cmp S2, P2
cmovge P1, P2
cmovle S2, P2
mov P2, S2
cmp S1, P2
cmovge S2, S1
cmovle P2, S1
cmp P1, P3
