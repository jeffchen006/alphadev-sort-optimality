# n=5 model=out iset=I1 prefix14_class=9196
cmp P3, P2
cmovle S2, P2
cmovg S2, P3
cmovge P3, P2
mov S0, P0
cmp P1, S0
cmovge P0, P1
cmovg P1, S0
cmp P1, P3
mov S1, P1
cmovge P1, P3
cmovl S1, P3
cmp P0, S2
cmovg P3, S1
