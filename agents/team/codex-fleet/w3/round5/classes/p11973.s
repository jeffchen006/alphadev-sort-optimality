# n=5 model=out iset=I1 prefix14_class=11973
mov S1, P2
cmp P0, P2
cmovg P2, P0
cmovge P0, S1
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
mov S0, P0
mov S2, P2
cmp P1, S0
cmovl S0, P1
cmovle P1, P0
cmovge P0, P1
