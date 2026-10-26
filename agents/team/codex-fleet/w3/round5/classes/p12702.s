# n=5 model=out iset=I1 prefix14_class=12702
cmp P2, P1
mov S1, P1
cmovg P1, P2
cmovg P2, S1
mov S2, P2
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
cmovl P0, S1
cmp P3, P2
cmovge P2, P3
cmovg P3, S2
cmp P0, P1
cmovg S0, P1
