# n=5 model=out iset=I1 prefix14_class=792
mov S1, P3
cmp P0, P2
mov S0, P0
cmovle S0, P2
cmovg P0, P2
cmp P3, P1
cmovg P3, P1
cmovg P1, S1
cmovl S1, P1
cmp S1, S0
cmovge P1, S0
mov P2, P0
cmovg S0, S1
mov S0, P1
