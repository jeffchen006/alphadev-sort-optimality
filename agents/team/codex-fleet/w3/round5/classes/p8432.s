# n=5 model=out iset=I1 prefix14_class=8432
mov S0, P1
cmp P1, P0
cmovg P1, P0
cmovge P0, S0
cmp P3, P2
mov S1, P2
cmovle S1, P3
cmovg P2, P3
cmp P0, P2
mov S2, P2
cmovg S2, P0
cmovge P0, P2
cmp P1, S1
cmovl S2, P1
