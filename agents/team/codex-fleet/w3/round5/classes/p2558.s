# n=5 model=out iset=I1 prefix14_class=2558
mov S1, P2
cmp P2, P1
cmovl P2, P1
cmovl P1, S1
mov S0, P0
cmp P3, P0
cmovg P0, P3
cmovge P3, S0
cmp P2, P0
cmovg S2, P2
cmovg P2, P0
cmovle S2, P0
mov S2, P2
cmp P1, P3
