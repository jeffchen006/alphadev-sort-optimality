# n=5 model=out iset=I1 prefix14_class=5764
cmp P1, P2
mov S0, P2
mov S1, P3
cmovge P2, P1
cmovge P1, S0
cmp P0, P3
cmovg S1, P0
mov S2, P1
cmovl P3, P0
cmp P3, S2
cmovg P1, P3
cmovle S2, P3
cmp P2, S1
mov S2, P2
