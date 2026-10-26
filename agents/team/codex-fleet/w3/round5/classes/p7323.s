# n=5 model=out iset=I1 prefix14_class=7323
cmp P3, P1
mov S0, P1
cmovle P1, P3
cmovg S0, P3
cmp P0, P2
mov P3, P2
cmovle P3, P0
cmovle P0, P2
mov P2, P3
cmp P3, P1
cmovg P3, P1
cmovge P1, P2
mov P3, P1
cmp S0, P0
