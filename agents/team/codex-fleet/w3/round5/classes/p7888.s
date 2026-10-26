# n=5 model=out iset=I1 prefix14_class=7888
mov S0, P1
cmp P1, P0
cmovg S0, P0
cmovge P0, P1
cmp P3, P2
cmovl P1, P3
cmovge P1, P2
cmovle P3, P2
cmp P1, S0
cmovg S2, P1
cmovg P1, S0
cmovg S0, S2
mov P2, P3
cmp P3, P0
