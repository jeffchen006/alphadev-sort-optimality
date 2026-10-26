# n=5 model=out iset=I1 prefix14_class=9075
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
mov S2, P1
cmovge P3, P0
cmp P1, P2
cmovle P1, P2
cmovl P2, S2
cmovl S2, P1
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmp P2, S0
cmovge P1, S0
