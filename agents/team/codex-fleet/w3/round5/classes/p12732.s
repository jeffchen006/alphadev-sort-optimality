# n=5 model=out iset=I1 prefix14_class=12732
mov S1, P3
cmp P1, P3
cmovg S1, P1
cmovle P3, P1
cmp P2, P0
mov P1, P2
cmovl P2, P0
cmovl P0, P1
cmovl P1, P2
cmp P0, P3
cmovge S0, P3
cmovge P3, P0
cmovg P0, S0
mov P0, P3
