# n=5 model=out iset=I1 prefix14_class=627
mov S0, P0
cmp P3, P2
cmovge S1, P3
cmovle S1, P2
cmovg P3, P2
cmp P0, P1
cmovg S0, P1
cmovge P1, P0
mov P2, S1
mov P0, P3
cmp P1, S1
cmovg S1, P1
cmovl P2, P1
mov S1, P2
