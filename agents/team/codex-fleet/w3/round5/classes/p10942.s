# n=5 model=out iset=I1 prefix14_class=10942
cmp P3, P2
mov S1, P2
cmovl P2, P3
cmovle P3, S1
mov S0, P3
cmp P1, P0
cmovg S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P0, S0
cmovge S0, P0
cmovl P3, P0
cmp P2, P1
cmovl P0, P1
