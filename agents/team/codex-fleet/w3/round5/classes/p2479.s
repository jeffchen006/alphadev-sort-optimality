# n=5 model=out iset=I1 prefix14_class=2479
cmp P1, P2
mov S0, P1
cmovg P1, P2
cmovle S0, P2
mov S2, P3
cmp P0, P3
cmovg S2, P0
mov S1, S0
cmovge P0, P3
cmp S0, S2
cmovle S1, S2
cmovl S2, S0
cmp P1, P0
cmovle P2, P1
