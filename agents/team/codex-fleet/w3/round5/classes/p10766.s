# n=5 model=out iset=I1 prefix14_class=10766
cmp P2, P0
cmovle S0, P2
cmovg S0, P0
cmovge P0, P2
cmp P3, P1
cmovl S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P3, P0
cmovl P2, P3
cmovle P3, P0
cmovl P0, P2
cmp S0, P1
cmovg S1, P1
