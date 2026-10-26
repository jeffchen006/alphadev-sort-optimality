# n=5 model=out iset=I1 prefix14_class=2194
cmp P1, P2
mov S0, P1
cmovle S0, P2
mov S2, P0
cmovge P1, P2
cmp P3, S2
cmovg S2, P3
mov S1, S2
cmovg P3, P0
cmp S2, S0
cmovl S1, S0
cmovle S0, S2
mov S1, S0
mov P2, P1
