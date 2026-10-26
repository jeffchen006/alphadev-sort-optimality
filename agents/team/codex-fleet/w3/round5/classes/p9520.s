# n=5 model=out iset=I1 prefix14_class=9520
mov S0, P3
mov S1, P1
cmp P2, S0
cmovge P3, P2
cmovle S0, P2
cmp S1, P0
cmovg S1, P0
cmovg P0, P1
cmp S0, S1
cmovle S2, S1
cmovl S1, S0
cmovle S0, S2
cmp P3, P0
cmovge P2, P3
