# n=5 model=out iset=I1 prefix14_class=3753
cmp P3, P2
mov S2, P1
cmovge S1, P2
cmovl S1, P3
cmovg P2, P3
cmp P0, P1
mov S0, S1
cmovg S2, P0
cmovge P0, P1
cmp P0, S1
cmovg S0, P0
cmovle S1, P0
mov P0, P2
cmp P0, S2
