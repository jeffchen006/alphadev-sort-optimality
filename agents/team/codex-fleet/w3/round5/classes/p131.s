# n=5 model=out iset=I1 prefix14_class=131
mov S1, P0
cmp S1, P1
cmovg P0, P1
cmovle S1, P1
mov S0, P2
cmp P3, P2
cmovge P2, P3
cmovle S0, P3
mov S2, P0
cmp S0, P0
cmovle S2, S0
cmovl S0, P0
mov P1, S1
cmp P2, P1
