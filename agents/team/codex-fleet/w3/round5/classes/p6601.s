# n=5 model=out iset=I1 prefix14_class=6601
cmp P1, P3
mov S0, P3
cmovge S0, P1
mov S1, P0
cmovl P3, P1
cmp S1, P2
cmovle P0, P2
cmovle P2, S1
mov P1, P2
cmp P0, S0
cmovg S1, S0
cmovg S0, P0
cmovg P0, S1
cmp P3, P2
