# n=5 model=out iset=I1 prefix14_class=2126
mov S2, P2
mov S0, P1
cmp P3, S0
cmovg S0, P3
cmovle P1, P3
cmp S2, P0
cmovle S2, P0
cmovge P2, P0
mov S1, S2
cmp S2, S0
cmovl S2, S0
mov S2, P1
cmovl S0, S1
mov S1, S0
