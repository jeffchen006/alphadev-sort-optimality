# n=5 model=out iset=I1 prefix14_class=7605
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
cmovl P0, S1
cmp P3, P1
mov S0, P1
cmovg P1, P3
cmovl S0, P3
cmovge P3, S0
cmp P0, S0
cmovg S0, P0
cmovle P3, P0
cmp P2, P1
cmovge P0, P1
