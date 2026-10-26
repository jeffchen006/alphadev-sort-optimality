# n=5 model=out iset=I1 prefix14_class=12753
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
cmovg P3, S0
mov S1, P3
cmp P2, P1
cmovg S2, P2
cmovle S2, P1
cmovl P1, P2
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
mov P1, P0
cmp P0, S2
