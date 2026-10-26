# n=5 model=out iset=I1 prefix14_class=6883
cmp P1, P0
mov S1, P3
mov S0, P1
cmovle P1, P0
cmovg S0, P0
cmp P3, P2
cmovl S1, P2
mov S2, S1
cmovge P3, P2
cmp P1, S2
cmovge S1, P1
cmovle S2, P1
cmp S0, P3
mov S1, S2
