# n=5 model=out iset=I1 prefix14_class=1298
mov S1, P3
cmp P3, P0
cmovg S1, P0
cmovle P3, P0
cmp P2, P1
mov P0, P2
cmovl P0, P1
mov S0, S1
cmovl P1, P2
mov S2, P0
cmp P0, P3
cmovge S2, P3
cmovl P0, P3
mov P3, S2
