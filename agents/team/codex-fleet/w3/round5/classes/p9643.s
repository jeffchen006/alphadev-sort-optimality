# n=5 model=out iset=I1 prefix14_class=9643
mov S1, P3
cmp P3, P2
cmovg P3, P2
cmovg P2, S1
mov S1, P1
cmp P1, P0
cmovg S1, P0
cmovl P1, P0
cmp P1, P2
mov P0, P1
cmovle P0, P2
cmovl P2, P1
cmp P3, S1
cmovge S0, S1
