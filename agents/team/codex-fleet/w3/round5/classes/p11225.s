# n=5 model=out iset=I1 prefix14_class=11225
mov S1, P0
cmp S1, P3
cmovl S1, P3
mov S0, P2
cmovg P0, P3
cmp P2, P1
cmovge P2, P1
cmovge P1, S0
cmp P1, S1
mov S2, P2
cmovle S0, S1
cmovl S1, P1
mov P3, S1
cmovle P1, S0
