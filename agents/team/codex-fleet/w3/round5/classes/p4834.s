# n=5 model=out iset=I1 prefix14_class=4834
cmp P0, P2
mov S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
mov S0, P2
cmovg P3, S1
cmp P1, P2
cmovg S0, P1
cmovle P2, P1
mov S1, S0
mov P2, P3
