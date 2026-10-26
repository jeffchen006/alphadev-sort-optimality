# n=5 model=out iset=I1 prefix14_class=9642
mov S1, P3
cmp P3, P2
cmovge P3, P2
cmovg P2, S1
mov S1, P1
cmp S1, P0
cmovg S1, P0
cmovle P1, P0
cmp P1, P2
mov P0, P1
cmovl P1, P2
cmovl P2, P0
cmp S1, P3
cmovle P1, S1
