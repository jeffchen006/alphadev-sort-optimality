# n=5 model=out iset=I1 prefix14_class=5798
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovge P2, P3
cmp P1, P0
mov S0, S2
cmovg P3, P1
cmovge P1, P0
cmovg P0, P3
cmp P1, S0
mov S1, P0
cmovg S2, P1
cmovle S0, P1
cmp P2, S1
