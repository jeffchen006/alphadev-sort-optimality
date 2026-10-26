# n=5 model=out iset=I1 prefix14_class=12967
mov S2, P1
cmp P2, S2
cmovg S2, P2
cmovle P1, P2
cmovge P2, P1
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, P0
cmovle P2, P0
cmovl P0, P1
mov P0, P3
cmp P3, S2
